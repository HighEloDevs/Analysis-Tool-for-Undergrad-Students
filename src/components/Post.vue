<template>
<v-container id="content-md" class="d-flex align-start my-3">
    <v-sheet class="d-none d-md-flex flex-column sticky-top mr-7" min-width="200px">
        <a
            v-for="(section, index) in sections"
            :key="index"
            :class="section.localName == 'h1' ? 'subtitle-1 mt-2 font-weight-bold teal--text' : 'ml-4 my-1 subtitle-2 font-weight-medium grey--text text--darken-1'"
            @click="scrollTo(section.id)"
        >
            {{section.innerHTML}}
        </a>
    </v-sheet>
    <span v-html="fromMarkdown(md)" id="text-content" class="text-justify"></span>
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
            sections: [],
            
        }
    },
    methods: {
        fromMarkdown(markdown){
            showdown.setFlavor('github');
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
        this.sections = document.querySelectorAll("h1, h2, h3")
        this.scrollTo(this.$route.params.section)
    },
}
</script>

<style lang="scss">
#content-md{
    @media screen and (min-width: 960px) {
        padding: 0 2%;
    }
    @media screen and (min-width: 1200px) {
        padding: 0 10%;
    }
    @media screen and (min-width: 1500px) {
        padding: 0 25%;
    }
}

.sticky-top {
    position: sticky;
    top: 0;
}

a{
    text-decoration: None;
    font-weight: 600;
}
</style>