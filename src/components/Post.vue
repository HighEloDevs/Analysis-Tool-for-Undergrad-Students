<template>
<v-container id="content" class="d-flex align-start px-md-16" fluid>
    <v-container class="ml-10 mr-0 pa-0 d-none d-md-flex flex-column sticky-top" fluid>
        <a
            v-for="(section, index) in sections"
            :key="index"
            :class="section.localName == 'h1' ? 'subtitle-1 mt-2 font-weight-bold teal--text text--darken-3' : 'ml-4 subtitle-2 teal--text font-weight-medium'"
            @click="scrollTo(section.id)"
        >
            {{section.innerHTML}}
        </a>
    </v-container>
    <span v-html="fromMarkdown(md)" id="text-content" class="text-justify pl-4 pr-0"></span>
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
                offset: -40,
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
#text-content{
    padding: 3%;
}
.sticky-top {
    position: sticky;
    max-width: 15%;
    top: 0;
}
</style>