<template>
    <v-container id="main-container" fluid class="d-flex align-center fill-height justify-center">
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
                    <v-card-title class="green--text lighten-3"> {{ section.title }} </v-card-title>
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
export default {
    name: 'TableOfContents',
    data() {
        return {
            sections: [
            {
                title: 'Instalação',
                icon: 'mdi-download',
                pages: [
                    { title: 'Windows', path: '/windows' },
                    { title: 'Linux', path: '/linux' },
                    { title: 'MacOS', path: '/macos' },
                ],
            },
            {
                title: 'Ajuste',
                icon: 'mdi-chart-bell-curve-cumulative',
                pages: [
                    { title: 'Carregando dados', path: '/plot-carregando' },
                    { title: 'Ajustando funções', path: '/plot-ajuste' },
                    { title: 'Customização', path: '/plot-custom' },
                ],
            },
            {
                title: 'Multiplot',
                icon: 'mdi-chart-multiple',
                pages: [
                    { title: 'Carregando dados', path: '/multiplot-carregando' },
                    { title: 'Customização', path: '/multiplot-custom' },
                ],
            },
            {
                title: 'Histogramas',
                icon: 'mdi-chart-bar',
                pages: [
                    { title: 'Carregando dados', path: '/hist-carregando' },
                    { title: 'Customização', path: '/hist-custom' },
                ],
            },
            {
                title: 'Calculadora',
                icon: 'mdi-chart-bell-curve',
                pages: [
                    { title: 'Utilização', path: '/calc-util' },
                ],
            },
            {
                title: 'Exemplos',
                icon: 'mdi-text-box-multiple-outline',
                pages: [
                    { title: 'Função linear', path: '/eg-linear' },
                    { title: 'Função exponencial', path: '/eg-exponential' },
                    { title: 'Funções especiais', path: '/eg-special' },
                    { title: 'Ajuste não convergiu', path: '/eg-converge' },
                ],
            },
        ]
        }
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