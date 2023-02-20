import { fetchUserProfile } from "./api";


export default async function initUserProfile() {
    const [localUserProfile, remoteUserData] = await Promise.all([
        chrome.storage.local.get("user"),
        fetchUserProfile()
    ]);

    if (!remoteUserData) {
        throw new Error("User Login")
    }

    const { user_id, user_name, avatar_large, description, follower_count, post_article_count, got_digg_count } = remoteUserData;

    const currentUserProfile = {
        userId: user_id,
        userName: user_name,
        avatar: avatar_large,
        description,
        followerCount: follower_count,
        postCount: post_article_count,
        likeCount: got_digg_count
    }

    if (currentUserProfile.userId !== localUserProfile.userId) {
        await chrome.storage.local.clear();
    }
    await chrome.storage.local.set({
        "user": currentUserProfile
    });

    return currentUserProfile;
}