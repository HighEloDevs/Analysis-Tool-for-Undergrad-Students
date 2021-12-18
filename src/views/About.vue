<template>
<v-container id="content" class="d-flex align-start px-md-16 " fluid>
    <div v-html="fromMarkdown(md)" id="text-content" class="text-justify"></div>
</v-container>
</template>

<script>
import showdown from "showdown"
import md from "!raw-loader!../md/About.md"

export default {
    name: "Post",
    data() {
      return {
        md: md,
        showdownOptions: {
            parseImgDimensions: true,
            strikethrough: true,
            tables: true,
            ghCodeBlocks: true,
            tasklists: true,
            emoji: true,
            underline: true,
            simpleLineBreaks: true,
        },
      }
    },
    methods: {
      fromMarkdown(markdown){
          showdown.setFlavor('vanilla');
          const converter = new showdown.Converter(this.showdownOptions);
          return converter.makeHtml(markdown);
      },
    },
}
</script>

<style lang="scss">
@media(min-width: 960px){
    #text-content{
        margin: 0 20%;
    }
}
</style>