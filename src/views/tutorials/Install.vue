<template>
<Post :md="md" :section="$route.params.section"></Post>
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
}
</script>