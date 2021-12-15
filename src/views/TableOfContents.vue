<template>
    <v-container id="main-container" fluid class="d-flex align-center flex-column">
        <div id="display" class="font-weight-medium"></div>
        <v-slide-x-transition slot="append">
            <v-sheet class="d-flex flex-wrap justify-center">
                <v-card 
                    outlined 
                    class="ma-4"
                    v-for="section in sections"
                    :key="section.id"
                    width="20em"  
                >
                    <v-card-title class="teal--text lighten-3"> {{ section.title }} </v-card-title>
                    <v-card-text>
                    <v-list rounded>
                        <v-list-item 
                            v-for="item in section.pages" 
                            :key="item.id" link
                            :to="item.path"
                        >
                        <v-list-item-content>
                            <v-list-item-title>
                                {{ item.title }}
                            </v-list-item-title>
                        </v-list-item-content>
                        </v-list-item>
                    </v-list>
                    </v-card-text>
                </v-card>
            </v-sheet>
        </v-slide-x-transition>

    </v-container>
</template>

<script>
import TypeIt from "typeit";
import { mapState } from 'vuex'
export default {
    name: 'TableOfContents',
    data() {
        return {
            //
        }
    },

    computed: {
        ...mapState([
        'sections'
        ]),
    },

    mounted() {
        this.typeit = new TypeIt('#display', {
            speed: 20,
        })
        .type("Documentação")
        .go()
    },
}
</script>

<style lang="scss" scoped>
@import url('https://fonts.googleapis.com/css2?family=Source+Code+Pro:wght@500&display=swap');
#main-container {
  height: 100%;
  font-family: 'Source Code Pro', monospace;
}
#display{
  font-size: 2em;
  text-align: center;
}
</style>