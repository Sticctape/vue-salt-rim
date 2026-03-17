<script setup lang="ts">
import { computed, getCurrentInstance } from 'vue'

const instance = getCurrentInstance()

const parentFile = computed(() => {
    const parentType = instance?.parent?.type as any
    return parentType?.__file ?? 'unknown'
})

const showDebugLabel = computed(() => {
    if (!import.meta.env.DEV) {
        return false
    }

    try {
        return new URLSearchParams(window.location.search).has('debugOverlays')
    } catch {
        return false
    }
})
</script>

<template>
    <div class="overlay-loader" :data-overlay-parent="parentFile">
        <div v-if="showDebugLabel" class="overlay-loader__debug">{{ parentFile }}</div>
    </div>
</template>

<style scoped>
@keyframes p-skeleton-animation {
    from {
        transform: translateX(-100%);
    }
    to {
        transform: translateX(100%);
    }
}

.overlay-loader {
    --ol-clr-bg: rgba(231, 222, 231, 0.7);
    position: absolute;
    overflow: hidden;
    top: 0;
    left: 0;
    display: flex;
    background: var(--ol-clr-bg);
    width: 100%;
    height: 100%;
    justify-content: center;
    z-index: var(--z-overlay-loader);
    backdrop-filter: blur(1px);
}

.overlay-loader__debug {
    position: absolute;
    top: 0.5rem;
    left: 0.5rem;
    z-index: 2;
    padding: 0.25rem 0.5rem;
    font-size: 12px;
    line-height: 1.2;
    border-radius: 4px;
    background: rgba(0, 0, 0, 0.7);
    color: #fff;
    max-width: calc(100% - 1rem);
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.overlay-loader:after {
    content: "";
    animation: p-skeleton-animation 0.7s infinite;
    height: 100%;
    left: 0;
    position: absolute;
    right: 0;
    top: 0;
    transform: translateX(-100%);
    z-index: 1;
    background: linear-gradient(90deg,rgba(243, 236, 243,0),rgba(243, 236, 243,0.7),rgba(243, 236, 243,0));
}

.dark-theme .overlay-loader {
    --ol-clr-bg: rgba(30, 23, 36, 0.7);
}

.dark-theme .overlay-loader:after {
    background: linear-gradient(90deg,rgba(30, 23, 36, 0),rgba(94, 89, 99, 0.9),rgba(30, 23, 36, 0));
}
</style>
