<template>
<Post :md="md"></Post>
</template>

<script>
import md from "!raw-loader!../../md/Install.md"
import Post from "@/components/Post.vue"
export default {
    name: "Install",
    components: {
        Post
    },
    data() {
        return {
            md: md,
        }
    },
    methods: {
    }
}
</script>