import Vue from 'vue';
import Vuetify from 'vuetify/lib/framework';

Vue.use(Vuetify);

export default new Vuetify({
    theme: {
        themes: {
            light: {
                primary: "#687dbb",
                secondary: "#3972aa",
                accent: "#9c7eb8",
            },
            dark: {
                primary: "#8f9cda",
                secondary: "#3972aa",
                accent: "#9c7eb8",
            },
        },
    },
});
