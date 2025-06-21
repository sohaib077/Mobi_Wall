/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const {onValueWritten} = require("firebase-functions/v2/database");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");
const logger = require("firebase-functions/logger");
const cors = require("cors")({origin: true}); // Enable CORS for all origins
const axios = require("axios"); // For geocoding API calls

// Initialize Firebase Admin SDK
initializeApp();

/**
 * Configuration for geocoding services
 * To use Google Geocoding API, set your API key in Firebase Functions config:
 * firebase functions:config:set geocoding.google_api_key="YOUR_API_KEY"
 */
const GEOCODING_CONFIG = {
  // Set to true to use Google Geocoding API (requires API key)
  useGoogle: false,
  // Google API key (get from Firebase Functions config)
  googleApiKey: process.env.GOOGLE_GEOCODING_API_KEY,
};

/**
 * Get human-readable address from coordinates using Google Geocoding API
 * @param {number} latitude - Latitude coordinate
 * @param {number} longitude - Longitude coordinate
 * @return {Promise<string>} Human-readable address
 */
async function getAddressFromGoogleGeocoding(latitude, longitude) {
  try {
    const apiKey = GEOCODING_CONFIG.googleApiKey;
    if (!apiKey) {
      throw new Error("Google Geocoding API key not configured");
    }

    const url = `https://maps.googleapis.com/maps/api/geocode/json?latlng=${latitude},${longitude}&key=${apiKey}`;
    const response = await axios.get(url);

    if (response.data.status === "OK" && response.data.results.length > 0) {
      const result = response.data.results[0];
      return result.formatted_address;
    } else {
      throw new Error(`Google Geocoding API error: ${response.data.status}`);
    }
  } catch (error) {
    logger.error("Error with Google Geocoding API", {
      error: error.message,
      latitude: latitude,
      longitude: longitude,
      structuredData: true,
    });
    throw error;
  }
}

/**
 * Get human-readable address from coordinates
 * @param {number} latitude - Latitude coordinate
 * @param {number} longitude - Longitude coordinate
 * @return {Promise<string>} Human-readable address
 */
async function getAddressFromNominatim(latitude, longitude) {
  try {
    const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}&zoom=18&addressdetails=1`;

    const response = await axios.get(url, {
      headers: {
        "User-Agent": "MobiWall-Firebase-Functions/1.0",
      },
      timeout: 5000, // 5 second timeout
    });

    if (response.data && response.data.display_name) {
      return response.data.display_name;
    } else {
      throw new Error("No address found in Nominatim response");
    }
  } catch (error) {
    logger.error("Error with Nominatim Geocoding", {
      error: error.message,
      latitude: latitude,
      longitude: longitude,
      structuredData: true,
    });
    throw error;
  }
}

/**
 * Extract important parts from a full address for notifications
 * @param {string} fullAddress - Complete address from geocoding service
 * @return {string} Shortened address with important parts only
 */
function getShortAddress(fullAddress) {
  try {
    if (!fullAddress || typeof fullAddress !== "string") {
      return "Unknown Location";
    }

    // Split address by commas and clean up
    const parts = fullAddress.split(",").map((part) => part.trim());

    // For very short addresses, return as is
    if (parts.length <= 2) {
      return fullAddress;
    }

    // Extract important components based on common address patterns
    const shortParts = [];

    // Take first part (usually street/building name)
    if (parts[0] && !parts[0].match(/^\d+$/)) {
      shortParts.push(parts[0]);
    }

    // Look for city/district (usually appears before state/country)
    for (let i = 1; i < Math.min(parts.length, 4); i++) {
      const part = parts[i];
      // Skip postal codes, country codes, and very long parts
      if (
        !part.match(/^\d+$/) &&
        !part.match(/^[A-Z]{2,3}$/) &&
        part.length < 30 &&
        !part.toLowerCase().includes("unnamed")
      ) {
        shortParts.push(part);
        break; // Take only one middle part
      }
    }

    // Add last meaningful part (city/country)
    const lastPart = parts[parts.length - 1];
    if (
      lastPart &&
      lastPart.length < 20 &&
      !shortParts.includes(lastPart) &&
      !lastPart.match(/^\d+$/)
    ) {
      shortParts.push(lastPart);
    }

    // Limit to maximum 3 parts to keep it short
    const result = shortParts.slice(0, 3).join(", ");

    // If result is too long, take only first and last part
    if (result.length > 50 && shortParts.length > 2) {
      return `${shortParts[0]}, ${shortParts[shortParts.length - 1]}`;
    }

    return result || "Near coordinates";
  } catch (error) {
    logger.warn("Error shortening address", {
      error: error.message,
      fullAddress: fullAddress,
      structuredData: true,
    });
    return "Location detected";
  }
}

/**
 * Get human-readable address from coordinates with fallback options
 * @param {number} latitude - Latitude coordinate
 * @param {number} longitude - Longitude coordinate
 * @return {Promise<string>} Human-readable address or formatted coordinates
 */
async function getLocationName(latitude, longitude) {
  try {
    logger.info("Getting location name for coordinates", {
      latitude: latitude,
      longitude: longitude,
      useGoogle: GEOCODING_CONFIG.useGoogle,
      structuredData: true,
    });

    let address = null;

    // Try Google Geocoding API first if configured
    if (GEOCODING_CONFIG.useGoogle && GEOCODING_CONFIG.googleApiKey) {
      try {
        const fullAddress = await getAddressFromGoogleGeocoding(
            latitude,
            longitude,
        );
        address = getShortAddress(fullAddress);
        logger.info("Successfully got address from Google Geocoding", {
          fullAddress: fullAddress,
          shortAddress: address,
          structuredData: true,
        });
        return address;
      } catch (error) {
        logger.warn("Google Geocoding failed, trying fallback", {
          error: error.message,
          structuredData: true,
        });
      }
    }

    // Fallback to OpenStreetMap Nominatim (Free)
    try {
      const fullAddress = await getAddressFromNominatim(latitude, longitude);
      address = getShortAddress(fullAddress);
      logger.info("Successfully got address from Nominatim", {
        fullAddress: fullAddress,
        shortAddress: address,
        structuredData: true,
      });
      return address;
    } catch (error) {
      logger.warn("Nominatim geocoding failed", {
        error: error.message,
        structuredData: true,
      });
    }

    // Final fallback: return formatted coordinates
    const formattedCoords = `${latitude.toFixed(4)}, ${longitude.toFixed(4)}`;
    logger.info("Using formatted coordinates as fallback", {
      coordinates: formattedCoords,
      structuredData: true,
    });
    return formattedCoords;
  } catch (error) {
    logger.error("Error in getLocationName", {
      error: error.message,
      latitude: latitude,
      longitude: longitude,
      structuredData: true,
    });
    // Return formatted coordinates as last resort
    return `${latitude.toFixed(4)}, ${longitude.toFixed(4)}`;
  }
}

/**
 * HTTP endpoint to store AI behavior analysis results in Firestore
 * POST /storeBehaviorAnalysis
 * Body: {
 *   parentId: string,
 *   childName: string,
 *   result: {
 *     Behavior: string,
 *     Music: number,
 *     Other: number,
 *     Percentages: {
 *       Music: number,
 *       Other: number,
 *       "Social Media": number
 *     },
 *     "Social Media": number
 *   }
 * }
 */
exports.storeBehaviorAnalysis = onRequest(async (req, res) => {
  return cors(req, res, async () => {
    // Only allow POST requests
    if (req.method !== "POST") {
      res.status(405).json({error: "Method not allowed"});
      return;
    }

    try {
      const {parentId, childName, result} = req.body;

      console.log("Received request body:", req.body);
      // Validate input data
      if (!parentId || !childName || !result) {
        res.status(400).json({
          error: "Missing required fields: parentId, childName and result",
        });
        return;
      }

      // Validate result structure
      if (!result.Behavior || typeof result.Percentages !== "object") {
        res.status(400).json({
          error: "Invalid result structure",
        });
        return;
      }

      logger.info("Storing behavior analysis", {
        parentId: parentId,
        childName: childName,
        behavior: result.Behavior,
        structuredData: true,
      });

      const db = getFirestore();

      // Create the document data with timestamp
      const analysisData = {
        behavior: result.Behavior,
        appUsage: {
          music: result.Music || 0,
          other: result.Other || 0,
          socialMedia: result["Social Media"] || 0,
        },
        percentages: {
          music: result.Percentages.Music || 0,
          other: result.Percentages.Other || 0,
          socialMedia: result.Percentages["Social Media"] || 0,
        },
        createdAt: new Date(),
      };

      // Store in Firestore under users/{parentId}/children/{childName}
      const childDocRef = db
          .collection("users")
          .doc(parentId)
          .collection("children")
          .doc(childName)
          .collection("behaviorAnalysis")
          .doc();
      await childDocRef.set(analysisData, {merge: true});

      // Send notification if behavior is Bad or Very Bad
      await sendNotificationIfNeeded(db, parentId, childName, result.Behavior);

      logger.info("Successfully stored behavior analysis", {
        documentPath: `users/${parentId}/children/${childName}`,
        parentId: parentId,
        childName: childName,
        structuredData: true,
      });

      res.status(200).json({
        success: true,
        documentPath: `users/${parentId}/children/${childName}`,
        message: "Behavior analysis stored successfully",
      });
    } catch (error) {
      logger.error("Error storing behavior analysis", {
        error: error.message,
        structuredData: true,
      });

      res.status(500).json({
        error: `Failed to store behavior analysis: ${error.message}`,
      });
    }
  });
});

/**
 * Send notification to parent if child behavior is Bad or Very Bad
 * @param {FirebaseFirestore.Firestore} db - Firestore database instance
 * @param {string} parentId - Parent's user ID
 * @param {string} childName - Child's name
 * @param {string} behavior - Child's behavior status
 */
async function sendNotificationIfNeeded(db, parentId, childName, behavior) {
  try {
    // Check if behavior requires notification
    if (behavior !== "Bad" && behavior !== "Very Bad") {
      logger.info("No notification needed", {
        behavior: behavior,
        childName: childName,
        structuredData: true,
      });
      return;
    }

    // Get parent's FCM token from Firestore
    const parentDoc = await db.collection("users").doc(parentId).get();

    if (!parentDoc.exists) {
      logger.warn("Parent document not found", {
        parentId: parentId,
        structuredData: true,
      });
      return;
    }

    const parentData = parentDoc.data();
    const fcmToken = parentData.token;

    if (!fcmToken) {
      logger.warn("Parent FCM token not found", {
        parentId: parentId,
        structuredData: true,
      });
      return;
    }

    // Prepare notification message
    const message = {
      token: fcmToken,
      notification: {
        title: "⚠️ Child Behavior Alert",
        body: `${childName}'s behavior is ${behavior}.`,
      },
      data: {
        type: "behavior_alert",
        childName: childName,
        behavior: behavior,
        parentId: parentId,
        timestamp: new Date().toISOString(),
      },
      android: {
        notification: {
          icon: "ic_notification",
          color: "#FF5722",
          channelId: "behavior_alerts",
          priority: "high",
        },
      },
      apns: {
        payload: {
          aps: {
            badge: 1,
            sound: "default",
          },
        },
      },
    };

    // Send notification
    const messaging = getMessaging();
    const response = await messaging.send(message);

    logger.info("Notification sent successfully", {
      messageId: response,
      parentId: parentId,
      childName: childName,
      behavior: behavior,
      structuredData: true,
    });
  } catch (error) {
    logger.error("Error sending notification", {
      error: error.message,
      parentId: parentId,
      childName: childName,
      behavior: behavior,
      structuredData: true,
    });
  }
}

/**
 * HTTP endpoint to store smartwatch data in Firestore
 * POST /storeSmartwatchData
 * Body: {
 *   parentId: string,
 *   childName: string,
 *   location: {
 *     latitude: number,
 *     longitude: number
 *   },
 *   heartRate: number
 * }
 */
exports.storeSmartwatchData = onRequest(async (req, res) => {
  // Set CORS headers
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  // Handle preflight OPTIONS request
  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  // Only allow POST requests
  if (req.method !== "POST") {
    res.status(405).json({error: "Method not allowed"});
    return;
  }

  try {
    const {parentId, childName, location, heartRate} = req.body;

    console.log("Received request body:", req.body);
    // Validate input data
    if (!parentId || !childName || !location || !heartRate) {
      res.status(400).json({
        error: "Missing parentId, childName, location, and heartRate",
      });
      return;
    }

    const db = getFirestore();

    // Create the document data with timestamp
    const smartwatchData = {
      location,
      heartRate,
      updatedAt: new Date(),
    };

    // Store in Firestore under users/{parentId}/children/{childName}
    const childDocRef = db
        .collection("users")
        .doc(parentId)
        .collection("children")
        .doc(childName);
    await childDocRef.set({smartwatchData}, {merge: true});

    // Send notification if heart rate is outside normal range (50-100 BPM)
    await sendHeartRateNotificationIfNeeded(db, parentId, childName, heartRate);

    res.status(200).json({
      success: true,
      documentPath: `users/${parentId}/children/${childName}/smartwatch`,
      message: "Smartwatch data stored successfully",
    });
  } catch (error) {
    logger.error("Error storing smartwatch data", {
      error: error.message,
      structuredData: true,
    });

    res.status(500).json({
      error: `Failed to store smartwatch data: ${error.message}`,
    });
  }
});

/**
 * Send notification to parent if child's heart rate is outside normal range
 * @param {FirebaseFirestore.Firestore} db - Firestore database instance
 * @param {string} parentId - Parent's user ID
 * @param {string} childName - Child's name
 * @param {number} heartRate - Child's heart rate
 */
async function sendHeartRateNotificationIfNeeded(
    db,
    parentId,
    childName,
    heartRate,
) {
  try {
    // Check if heart rate is outside normal range (50-100 BPM)
    if (heartRate >= 50 && heartRate <= 100) {
      logger.info("Heart rate is normal, no notification needed", {
        heartRate: heartRate,
        childName: childName,
        structuredData: true,
      });
      return;
    }

    // Get parent's FCM token from Firestore
    const parentDoc = await db.collection("users").doc(parentId).get();

    if (!parentDoc.exists) {
      logger.warn("Parent document not found", {
        parentId: parentId,
        structuredData: true,
      });
      return;
    }

    const parentData = parentDoc.data();
    const fcmToken = parentData.token;

    if (!fcmToken) {
      logger.warn("Parent FCM token not found", {
        parentId: parentId,
        structuredData: true,
      });
      return;
    }

    // Determine alert type and message
    const isHigh = heartRate > 100;
    const alertType = isHigh ? "High" : "Low";
    const emoji = isHigh ? "🔴" : "🔵";

    // Prepare notification message
    const message = {
      token: fcmToken,
      notification: {
        title: `${emoji} Heart Rate Alert`,
        body: `${childName}'s heart rate is ${alertType}: ${heartRate} BPM`,
      },
      data: {
        type: "heart_rate_alert",
        childName: childName,
        heartRate: heartRate.toString(),
        alertType: alertType,
        parentId: parentId,
        timestamp: new Date().toISOString(),
      },
      android: {
        notification: {
          icon: "ic_notification",
          color: isHigh ? "#FF5722" : "#2196F3",
          channelId: "health_alerts",
          priority: "high",
        },
      },
      apns: {
        payload: {
          aps: {
            badge: 1,
            sound: "default",
          },
        },
      },
    };

    // Send notification
    const messaging = getMessaging();
    const response = await messaging.send(message);

    logger.info("Heart rate notification sent successfully", {
      messageId: response,
      parentId: parentId,
      childName: childName,
      heartRate: heartRate,
      alertType: alertType,
      structuredData: true,
    });
  } catch (error) {
    logger.error("Error sending heart rate notification", {
      error: error.message,
      parentId: parentId,
      childName: childName,
      heartRate: heartRate,
      structuredData: true,
    });
  }
}

/**
 * Send emergency notification to parent
 * @param {FirebaseFirestore.Firestore} db - Firestore database instance
 * @param {string} parentId - Parent's user ID
 * @param {string} childName - Child's name
 * @param {string} source
 * @param {object} location - Optional location data with latitude and longitude
 */
async function sendEmergencyNotification(
    db,
    parentId,
    childName,
    source = "unknown",
    location = null,
) {
  try {
    logger.info("Sending emergency alert", {
      parentId: parentId,
      childName: childName,
      source: source,
      hasLocation: !!location,
      structuredData: true,
    });

    // Get parent's FCM token from Firestore
    const parentDoc = await db.collection("users").doc(parentId).get();

    if (!parentDoc.exists) {
      logger.warn("Parent document not found for emergency alert", {
        parentId: parentId,
        structuredData: true,
      });
      throw new Error("Parent not found");
    }

    const parentData = parentDoc.data();
    const fcmToken = parentData.token;

    if (!fcmToken) {
      logger.warn("Parent FCM token not found for emergency alert", {
        parentId: parentId,
        structuredData: true,
      });
      throw new Error("Parent notification token not found");
    }

    // Create notification body with location info if available
    let notificationBody = `${childName} is in an EMERGENCY situation!`;
    if (location && location.latitude && location.longitude) {
      try {
        // Get human-readable address from coordinates
        const locationName = await getLocationName(
            location.latitude,
            location.longitude,
        );
        notificationBody += `\nLocation: ${locationName}`;

        logger.info("Added location name to emergency notification", {
          locationName: locationName,
          coordinates: `${location.latitude}, ${location.longitude}`,
          structuredData: true,
        });
      } catch (error) {
        // Fallback to coordinates if geocoding fails
        notificationBody += `\nLocation: ${location.latitude.toFixed(
            4,
        )}, ${location.longitude.toFixed(4)}`;
        logger.warn("Geocoding failed, using coordinates", {
          error: error.message,
          structuredData: true,
        });
      }
    }

    // Prepare emergency notification message
    const message = {
      token: fcmToken,
      notification: {
        title: "🚨 EMERGENCY ALERT",
        body: notificationBody,
      },
      data: {
        type: "emergency_alert",
        childName: childName,
        parentId: parentId,
        timestamp: new Date().toISOString(),
        priority: "critical",
        source: source,
      },
      android: {
        notification: {
          icon: "ic_notification",
          color: "#FF0000",
          channelId: "emergency_alerts",
          priority: "max",
          sound: "default",
          tag: "emergency",
        },
      },
      apns: {
        payload: {
          aps: {
            badge: 1,
            sound: "default",
          },
        },
      },
    };

    // Add location data to notification payload if available
    if (location && location.latitude && location.longitude) {
      message.data.latitude = location.latitude.toString();
      message.data.longitude = location.longitude.toString();
    }

    // Send notification
    const messaging = getMessaging();
    const response = await messaging.send(message);

    logger.info("Emergency notification sent successfully", {
      messageId: response,
      parentId: parentId,
      childName: childName,
      source: source,
      structuredData: true,
    });

    return response;
  } catch (error) {
    logger.error("Error sending emergency notification", {
      error: error.message,
      parentId: parentId,
      childName: childName,
      source: source,
      structuredData: true,
    });
    throw error;
  }
}

/**
 * HTTP endpoint to send emergency notification to parent
 * POST /sendEmergencyAlert
 * Body: {
 *   parentId: string,
 *   childName: string
 * }
 */
exports.sendEmergencyAlert = onRequest(async (req, res) => {
  // Set CORS headers
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  // Handle preflight OPTIONS request
  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  // Only allow POST requests
  if (req.method !== "POST") {
    res.status(405).json({error: "Method not allowed"});
    return;
  }

  try {
    const {parentId, childName, location} = req.body;

    console.log("Received emergency alert request:", req.body);
    // Validate input data
    if (!parentId || !childName) {
      res.status(400).json({
        error: "Missing required fields: parentId and childName",
      });
      return;
    }

    const db = getFirestore();

    // Use the extracted emergency notification function
    const messageId = await sendEmergencyNotification(
        db,
        parentId,
        childName,
        "http_request",
        location, // Pass location data if provided
    );

    res.status(200).json({
      success: true,
      message: "Emergency alert sent successfully",
      messageId: messageId,
    });
  } catch (error) {
    logger.error("Error in sendEmergencyAlert endpoint", {
      error: error.message,
      structuredData: true,
    });

    if (error.message === "Parent not found") {
      res.status(404).json({error: error.message});
    } else if (error.message === "Parent notification token not found") {
      res.status(400).json({error: error.message});
    } else {
      res.status(500).json({
        error: `Failed to send emergency alert: ${error.message}`,
      });
    }
  }
});

/**
 * Realtime Database trigger for smartwatch data changes
 * Triggers when data is created or updated in
 * users/{parentId}/children/{childName}
 * Automatically calls storeSmartwatchData when smartwatch data is detected
 */
exports.onChildSmartwatchDataChanged = onValueWritten(
    "users/{parentId}/children/{childName}",
    async (event) => {
      const {parentId, childName} = event.params;
      const afterData = event.data.after.val();
      const beforeData = event.data.before.val();

      logger.info("Child data changed in Realtime Database", {
        parentId: parentId,
        childName: childName,
        hasAfterData: !!afterData,
        hasBeforeData: !!beforeData,
        structuredData: true,
      });

      console.log("Realtime Database change detected:", {
        parentId: parentId,
        childName: childName,
        afterData: afterData,
        beforeData: beforeData,
      });

      try {
      // Check if the data contains smartwatch information
      // Handle both wrapped (smartwatchData) and direct format
        let smartwatch = null;

        if (afterData && afterData.smartwatchData) {
          smartwatch = afterData.smartwatchData;
          logger.info("Smartwatch data found in wrapped format", {
            parentId: parentId,
            childName: childName,
            structuredData: true,
          });
        } else if (afterData && afterData.location && afterData.heartRate) {
          smartwatch = {
            location: afterData.location,
            heartRate: afterData.heartRate,
          };
          logger.info("Smartwatch data found in direct format", {
            parentId: parentId,
            childName: childName,
            structuredData: true,
          });
        }

        if (smartwatch && smartwatch.location && smartwatch.heartRate) {
          logger.info("Smartwatch data detected, processing...", {
            parentId: parentId,
            childName: childName,
            heartRate: smartwatch.heartRate,
            structuredData: true,
          });

          // Call the existing storeSmartwatchData logic
          await processSmartwatchData(parentId, childName, smartwatch);
        } else {
          logger.info("No valid smartwatch data found in any format", {
            parentId: parentId,
            childName: childName,
            hasAfterData: !!afterData,
            afterDataKeys: afterData ? Object.keys(afterData) : [],
            structuredData: true,
          });
        }
      } catch (error) {
        logger.error("Error processing child smartwatch data change", {
          error: error.message,
          parentId: parentId,
          childName: childName,
          structuredData: true,
        });
      }
    },
);

/**
 * Process smartwatch data (extracted from storeSmartwatchData)
 * @param {string} parentId - Parent's user ID
 * @param {string} childName - Child's name
 * @param {object} smartwatchData - Smartwatch data with location and heartRate
 */
async function processSmartwatchData(parentId, childName, smartwatchData) {
  try {
    logger.info("Processing smartwatch data", {
      parentId: parentId,
      childName: childName,
      heartRate: smartwatchData.heartRate,
      structuredData: true,
    });

    const db = getFirestore();

    // Create the document data with timestamp
    const processedData = {
      location: smartwatchData.location,
      heartRate: smartwatchData.heartRate,
      updatedAt: new Date(),
      source: "realtime_database_trigger", // Mark this as triggered by RT DB
    };

    // Store in Firestore under users/{parentId}/children/{childName}
    const childDocRef = db
        .collection("users")
        .doc(parentId)
        .collection("children")
        .doc(childName);
    await childDocRef.set({smartwatchData: processedData}, {merge: true});

    // Send notification if heart rate is outside normal range (50-100 BPM)
    await sendHeartRateNotificationIfNeeded(
        db,
        parentId,
        childName,
        smartwatchData.heartRate,
    );

    logger.info("Successfully processed smartwatch data from RT DB", {
      documentPath: `users/${parentId}/children/${childName}`,
      parentId: parentId,
      childName: childName,
      heartRate: smartwatchData.heartRate,
      structuredData: true,
    });
  } catch (error) {
    logger.error("Error processing smartwatch data from RT DB", {
      error: error.message,
      parentId: parentId,
      childName: childName,
      structuredData: true,
    });
    throw error;
  }
}

/**
 * Realtime Database trigger for emergency alerts
 * Triggers when alertedAt is created or updated in
 * alerts/{parentId}/children/{childName}
 * Automatically sends emergency notification when alert is detected
 */
exports.onEmergencyAlertTriggered = onValueWritten(
    "alerts/{parentId}/children/{childName}",
    async (event) => {
      const {parentId, childName} = event.params;
      const afterData = event.data.after.val();
      const beforeData = event.data.before.val();

      logger.info("Emergency alert data changed in Realtime Database", {
        parentId: parentId,
        childName: childName,
        hasAfterData: !!afterData,
        hasBeforeData: !!beforeData,
        structuredData: true,
      });

      console.log("Emergency alert trigger detected:", {
        parentId: parentId,
        childName: childName,
        afterData: afterData,
        beforeData: beforeData,
      });

      try {
      // Check if there's new alertedAt data
        if (afterData && afterData.alertedAt) {
          const newAlertedAt = afterData.alertedAt;
          const oldAlertedAt = beforeData && beforeData.alertedAt;

          // Only trigger if alertedAt is new or changed
          if (!oldAlertedAt || newAlertedAt !== oldAlertedAt) {
            logger.info("New emergency alert, sending notification...", {
              parentId: parentId,
              childName: childName,
              alertedAt: newAlertedAt,
              structuredData: true,
            });

            const db = getFirestore();

            // Store emergency alert info in Firestore for record keeping
            const emergencyData = {
              alertedAt: new Date(newAlertedAt),
              source: "realtime_database_trigger",
              processed: true,
            };

            // Include location data if available
            if (afterData.location) {
              emergencyData.location = afterData.location;
            }
            if (afterData.alertType) {
              emergencyData.alertType = afterData.alertType;
            }

            // Store in Firestore
            const alertDocRef = db
                .collection("users")
                .doc(parentId)
                .collection("children")
                .doc(childName)
                .collection("emergencyAlerts")
                .doc();
            await alertDocRef.set(emergencyData);

            // Send emergency notification with location data
            await sendEmergencyNotification(
                db,
                parentId,
                childName,
                "realtime_database_trigger",
                afterData.location,
            );

            logger.info("Emergency alert processed successfully", {
              documentPath: `users/${parentId}/children/${childName}/alerts`,
              parentId: parentId,
              childName: childName,
              alertedAt: newAlertedAt,
              structuredData: true,
            });
          } else {
            logger.info(
                "Emergency alert alertedAt unchanged, skipping notification",
                {
                  parentId: parentId,
                  childName: childName,
                  alertedAt: newAlertedAt,
                  structuredData: true,
                },
            );
          }
        } else {
          logger.info("No alertedAt field found in emergency alert data", {
            parentId: parentId,
            childName: childName,
            hasAfterData: !!afterData,
            afterDataKeys: afterData ? Object.keys(afterData) : [],
            structuredData: true,
          });
        }
      } catch (error) {
        logger.error("Error processing emergency alert from RT DB", {
          error: error.message,
          parentId: parentId,
          childName: childName,
          structuredData: true,
        });
      }
    },
);

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
