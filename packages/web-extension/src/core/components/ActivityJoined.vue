<script setup lang="ts">
import { inject, ref, toRef } from "vue";
import SectionHeader from "../base-components/SectionHeader.vue"
import useComputeJoinedArticleActivities from "../composables/useComputeJoinedArticleActivities";
import { IArticleActivity, IPinActivity } from "../types";
import { articleContentInjectionKey, articleListInjectionKey, IArticleContentInjectContentType, IArticleListInjectContentType } from "../utils/injectionKeys";
import ActivityCard from "./ActivityCard.vue";
import PinActivityList from "./PinActivityList.vue";

const props = defineProps<{
    activities: IArticleActivity[],
    pinActivities: IPinActivity[],
    hideTitle?: boolean
}>()

const activities = toRef(props, "activities");
const pinActivities = toRef(props, "pinActivities");


const articleList = inject<IArticleListInjectContentType>(articleListInjectionKey, ref([]))
const articleContentMap = inject<IArticleContentInjectContentType>(articleContentInjectionKey, ref(new Map()))


const joinedActivities = useComputeJoinedArticleActivities(activities, articleList, articleContentMap);

</script>

<template>
    <SectionHeader title="正在参与的活动" v-if="!hideTitle">
    </SectionHeader>
    <div class="gij-grid gij-gap-8 gij-grid-cols-2" v-if="joinedActivities.length">
        <ActivityCard v-for="activity in joinedActivities" class="gij-card" :activity="activity">
        </ActivityCard>
        <PinActivityList :activities="pinActivities" class="gij-card"></PinActivityList>
    </div>
    <div v-else
        class="gij-border gij-rounded-md gij-border-gray-1-2 gij-bg-layer-bg/80 gij-text-sm gij-text-center gij-p-4">
        <a href="https://github.com/curly210102/grow-in-juejin/issues/new" target="_blank"
            class="gij-block gij-text-primary hover:gij-text-primary-hover focus:gij-outline-none">
            未检测到正在参与的活动，如有差异请提交
            Issue
        </a>
    </div>
</template>