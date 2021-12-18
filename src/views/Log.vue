<template>
  <v-container fluid>
    <v-card 
      v-for="release in releases"
      :key="release.id"
      elevation="0"
      class="my-5"
    >
      <v-card class="flex-grow-1 pa-5" outlined elevation="0">
        <v-list two-line rounded>
          <v-list-item 
            link 
            :href="release.html_url"
            target="_blank"  
          >
            <v-list-item-avatar>
              <v-avatar size="30px">
                <v-img
                  :src='release.author.avatar_url'
                ></v-img>
              </v-avatar>
            </v-list-item-avatar>
            <v-list-item-content>
              <v-list-item-subtitle> {{ parseDate(release.published_at) }} </v-list-item-subtitle>
              <v-list-item-title> {{ release.author.login }} </v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
        <span v-html="fromMarkdown(release.body)"></span>
        <p class="font-weight-bold title my-4">Downloads: <span class="teal--text">{{release.assets[0].download_count}}</span></p>
        <v-card-actions>
          <v-btn
            :href="release.assets[0].browser_download_url"
            target="_blank"
            color="primary"
            outlined
          >
            .exe
          </v-btn>
          <v-btn
            :href="release.tarball_url"
            target="_blank"
            color="primary"
            outlined
          >
            .tar
          </v-btn>
          <v-btn
            :href="release.zipball_url"
            target="_blank"
            color="primary"
            outlined
          >
            .zip
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-card>
    <h4>Total de Downloads: {{this.total_downloads}}</h4>
  </v-container>
</template>

<script>
  import { Octokit } from "@octokit/core"
  import showdown from "showdown"

  export default {
    name: 'Log',

    data: () => ({
      releases: [],
      total_downloads: null,
    }),

    methods: {
      async getReleases(octokit) {
        await octokit.request('GET /repos/{owner}/{repo}/releases', {
          owner: "HighEloDevs",
          repo: "Analysis-Tool-for-Undergrad-Students"
        }).then(res => {
          this.releases = res.data;
          this.getTotalDownloads()
        });
      },

      parseDate(date){
        return new Date(date).toLocaleDateString();
      },

      fromMarkdown(markdown){
        const converter = new showdown.Converter();
        return converter.makeHtml(markdown);
      },

      getTotalDownloads(){
        let total = 0;
        this.releases.forEach(release => {
          total += release.assets[0].download_count;
        });
        this.total_downloads = total;
      },
    },

    mounted() {
      const octokit = new Octokit();
      this.getReleases(octokit);
    },
  }
</script>