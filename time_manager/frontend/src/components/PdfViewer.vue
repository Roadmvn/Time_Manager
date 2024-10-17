<template>
  <div class="pdf-viewer">
    <div>
      <iframe :src="pdfUrl" width="100%" height="600px"></iframe>
      
    </div>
  </div>
</template>

<script>
export default {
  name: 'PdfViewer',
  props: {
    pdfFilePath: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      pdfUrl: null,
    };
  },
  mounted() {
    this.setPdfUrl();
  },
  methods: {
    setPdfUrl() {
      if (this.pdfFilePath) {
        this.pdfUrl = `${window.location.origin}/${this.pdfFilePath}`;
        console.log('PDF URL:', this.pdfUrl); 
      }
    },
  },
}
</script>

<style scoped>
.pdf-viewer iframe {
  border: none;
}
</style>
