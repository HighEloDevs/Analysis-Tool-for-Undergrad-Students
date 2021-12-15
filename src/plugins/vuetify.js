import Vue from 'vue';
import Vuetify from 'vuetify/lib/framework';

Vue.use(Vuetify);

export default new Vuetify({
    theme: {
        themes: {
            light: {
                primary: "#009688",
                secondary: "#3972aa",
                accent: "#9c7eb8",
            },
            dark: {
                primary: "#009688",
                secondary: "#3972aa",
                accent: "#9c7eb8",
            },
        },
    },
});
