/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const logger = require("firebase-functions/logger");

// Initialize Firebase Admin SDK
initializeApp();

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
    const {parentId, childName, result} = req.body;

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
      parentId: parentId,
      childName: childName,
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

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
