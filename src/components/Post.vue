<template>
<v-container id="content" class="d-flex align-start" fluid>
    <v-container class="mr-8 pa-2 d-none d-md-flex flex-column sticky-top" fluid>
        <a
            v-for="(section, index) in sections"
            :key="index"
            :class="section.localName == 'h1' ? 'subtitle-1 mt-2 font-weight-bold teal--text text--darken-3' : 'ml-4 subtitle-2 teal--text font-weight-medium'"
            @click="scrollTo(section.id)"
        >
            {{section.innerHTML}}
        </a>
    </v-container>
    <span v-html="fromMarkdown(md)" id="text" class="text-justify"></span>
</v-container>
</template>

<script>
import showdown from "showdown"

export default {
    name: "Post",
    props: ['md', 'section'],
    data() {
        return {
            options: {
                duration:400,
                container: "#content",
                offset: 50,
            },
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
            btn: null,
            sections: []
        }
    },
    methods: {
        fromMarkdown(markdown){
            showdown.setFlavor('vanilla');
            const converter = new showdown.Converter(this.showdownOptions);
            return converter.makeHtml(markdown);
        },
        scrollTo(element){
            if(element != undefined) this.$vuetify.goTo(`#${element}`, this.options)
        },
    },
    watch: {
        $route(){
            this.scrollTo(this.$route.params.section)
        }
    },
    mounted() {
        this.sections = document.querySelectorAll("h1, h2")
        this.scrollTo(this.$route.params.section)
    },
}
</script>

<style>
#content{
    padding: 2%;
}
.sticky-top {
    position: sticky;
    top: 0;
    max-width: 15%;
}
</style>