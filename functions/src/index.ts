import { onDocumentWritten } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

/**
 * Cloud Function: aggregateRewardStats
 *
 * Triggered on every reward write under /rewards/{rewardId}.
 * Aggregates total points and prayer counts back onto the
 * parent memorial document at /memorials/{memorialId}.
 *
 * This runs server-side so the numbers are always authoritative
 * regardless of client state.
 */
export const aggregateRewardStats = onDocumentWritten(
  "rewards/{rewardId}",
  async (event) => {
    const rewardId = event.params.rewardId;
    const change = event.data;

    // Determine the memorialId from the new or previous data
    const memorialId =
      change?.after.data()?.memorialId ??
      change?.before.data()?.memorialId;

    if (!memorialId) {
      console.warn(`No memorialId found for reward ${rewardId}`);
      return;
    }

    // Aggregate all rewards for this memorial
    const rewardsSnap = await db
      .collection("rewards")
      .where("memorialId", "==", memorialId)
      .get();

    let totalPoints = 0;
    let totalCount = 0;

    rewardsSnap.forEach((doc) => {
      const data = doc.data();
      totalPoints += (data.points as number) ?? 0;
      totalCount += (data.count as number) ?? 0;
    });

    // Update the memorial with aggregated stats
    await db.collection("memorials").doc(memorialId).update({
      prayerCount: totalPoints,
      totalRewardCount: totalCount,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(
      `Aggregated ${rewardsSnap.size} rewards for memorial ${memorialId}: ` +
        `${totalPoints} points, ${totalCount} count`
    );
  }
);

/**
 * Cloud Function: cleanupOrphanedRewards
 *
 * Placeholder for a scheduled function that removes reward
 * documents whose parent memorial no longer exists.
 *
 * To activate: uncomment and deploy with a cron trigger.
 */
/*
export const cleanupOrphanedRewards = onSchedule(
  "every 24 hours",
  async () => {
    const memorialsSnap = await db.collection("memorials").get();
    const validMemorialIds = new Set<string>();
    memorialsSnap.forEach((doc) => validMemorialIds.add(doc.id));

    const rewardsSnap = await db.collection("rewards").get();
    const batch = db.batch();
    let orphanCount = 0;

    rewardsSnap.forEach((doc) => {
      const memorialId = doc.data().memorialId;
      if (!validMemorialIds.has(memorialId)) {
        batch.delete(doc.ref);
        orphanCount++;
      }
    });

    if (orphanCount > 0) {
      await batch.commit();
      console.log(`Cleaned up ${orphanCount} orphaned rewards`);
    }
  }
);
 */

/**
 * Cloud Function: onMemorialDeleted
 *
 * Placeholder that cascades deletion of all rewards when
 * a memorial document is deleted.
 */
export const onMemorialDeleted = onDocumentWritten(
  "memorials/{memorialId}",
  async (event) => {
    if (event.data?.after.exists) return;

    const memorialId = event.params.memorialId;
    const limit = 500;
    let totalDeleted = 0;

    while (true) {
      const snap = await db
        .collection("rewards")
        .where("memorialId", "==", memorialId)
        .limit(limit)
        .get();

      if (snap.empty) break;

      const batch = db.batch();
      snap.forEach((doc) => batch.delete(doc.ref));
      await batch.commit();

      totalDeleted += snap.size;
      if (snap.size < limit) break;
    }

    console.log(
      `Cascaded deletion of ${totalDeleted} rewards for memorial ${memorialId}`
    );
  }
);
