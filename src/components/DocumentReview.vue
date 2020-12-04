<template>
  <div
    v-if="contract"
    class="document-review flex flex-col p-6 overflow-hidden h-screen"
  >
    <div class="flex-1 flex flex-col py-4 space-y-4 bg-white rounded shadow">
      <div class="tabs px-6">
        <ul>
          <li>
            <a 
              :class="{'bg-indigo-400 text-indigo-100': activeTab === 'document_tab'}" 
              href="javascript:;" 
              class="bg-gray-100 uppercase font-semibold text-sm rounded px-4 py-3 hover:bg-indigo-400 hover:text-indigo-100" 
              @click.prevent="activateTab('document_tab')">View Document</a>
            <a 
              :class="{'bg-indigo-400 text-indigo-100': activeTab === 'signature_tab'}" 
              href="javascript:;" 
              class="bg-gray-100 uppercase font-semibold text-sm rounded px-4 py-3 hover:bg-indigo-400 hover:text-indigo-100" 
              @click.prevent="activateTab('signature_tab')" >View Signatures</a>
          </li>
        </ul>
      </div>
      <div 
        v-if="activeTab === 'signature_tab'" 
        class="flex flex-col">
        <table 
          v-if="signatures" 
          class="w-full">
          <thead>
            <tr>
              <th class="py-2 px-2 border-t text-left">Address</th>
              <th class="py-2 px-2 border-t text-left">Status</th>
            </tr>
          </thead>
          <tbody>
            <tr 
              v-for="(signature, index) in signatures" 
              :key="index"
              class="hover:bg-gray-100">
              <td class="py-2 px-2 border-t">{{ signature.owner }}</td>
              <td class="py-2 px-2 border-t">{{ signature.status|statusToString }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div 
        v-if="activeTab === 'document_tab'" 
        class="flex flex-col space-y-2">
        <div 
          class="flex px-6 justify-between">
          <div class="font-semibold">Owner</div>
          <div class="">
            <a
              :href="'https://goerli.etherscan.io/address/' + owner"
              class="text-blue-500"
              target="_blank"
            >
              {{ owner }}</a
              >
          </div>
        </div>
        <div class="flex px-6 justify-between">
          <div class="font-semibold">Original Document</div>
          <div class="">
            <a 
              :href="documentPath" 
              class="text-blue-500" 
              target="_blank">{{
                path | truncate(80)
              }}</a>
          </div>
        </div>
        <div class="flex px-6 justify-between">
          <div class="font-semibold">Contract</div>
          <div class="">
            <a 
              :href="documentPath" 
              class="text-blue-500" 
              target="_blank">{{
                contractHash | truncate(80)
              }}</a>
          </div>
        </div>
        <div class="flex px-6 justify-between">
          <div class="font-semibold">Signing status</div>
          <div 
            v-if="completed" 
            class="bg-green-600 text-green-100 px-2 py-1">
            Completed
          </div>
          <div 
            v-if="!completed" 
            class="bg-yellow-600 text-yellow-100 px-2 py-1">
            In progress
          </div>
        </div>
      </div>
    </div>

    <!-- Embed Document -->
    <div v-if="activeTab === 'document_tab'">
      <div class="flex-1">
        <embed
          :src="documentPath"
          type="application/pdf"
          width="100%"
          height="100vh"
          class="h-screen"
        >
      </div>

      <!-- Action panel -->
      <div class="fixed bottom-10 right-10 space-x-2">
        <button
          class="px-4 py-2 bg-green-600 text-green-100 rounded shadow focus:outline-none"
          @click="downloadSigned"
        >
          Download Signed
        </button>
        <button
          class="px-4 py-2 bg-red-600 text-red-100 rounded shadow focus:outline-none"
          @click="decline"
        >
          Reject
        </button>
        <button
          class="px-4 py-2 bg-indigo-600 text-indigo-100 rounded shadow focus:outline-none"
          @click="approve"
        >
          Sign
        </button>
      </div>
    </div>
  </div>
</template>

<script>
var FileSaver = require("file-saver");
import { PDFDocument, rgb, StandardFonts } from "pdf-lib";
import contractJson from "./../../build/contracts/DecentraDocuSign.json";
export default {
  name: "DocumentReview",
  filters: {
    statusToString(val) {
      if (val === '0') return 'Pending'
      if (val === '1') return 'Signed For'
      if (val === '2') return 'Rejected'
    }
  },
  data() {
    return {
      path: "",
      owner: "",
      completed: "",
      signers: [],
      signatures: [],
      contract: "",
      activeTab: "document_tab"
    };
  },
  computed: {
    contractHash() {
      return this.$route.params.hash;
    },
    documentPath() {
      return "http://ipfs.io/ipfs/" + this.path;
    },
  },
  created() {
    this.loadContract();
    if (this.contract) {
      this.getDocumentDetails();
    }
  },
  methods: {
    activateTab(selection){
      this.activeTab = selection
    },
    loadContract() {
      let self = this;
      this.contract = new window.web3.eth.Contract(
        contractJson.abi,
        this.contractHash,
        {
          from: self.$store.getters.getAccount,
          gasPrice: 20000000000,
          gasLimit: 210000,
        }
      );
    },
    async getDocumentDetails() {
      let self = this;
      self.contract.methods
        .document()
        .call()
        .then((res) => {
          self.path = res;
        });

      self.contract.methods
        .owner()
        .call()
        .then((res) => {
          self.owner = res;
        });

      self.contract.methods
        .completed()
        .call()
        .then((res) => {
          self.completed = res;
        });

      let signersCount =
        (await self.contract.methods.signersCount().call()) || 0;

      for (let i = 0; i < signersCount; i++) {
        self.contract.methods
          .signers(i)
          .call()
          .then((res) => {
            self.signers.push(res);
          });
      }

      for (let i = 0; i < signersCount; i++) {
        self.contract.methods
          .signers(i)
          .call()
          .then((addr) => {
            self.contract.methods
              .signatures(addr)
              .call()
              .then((signature) => {
                self.signatures.push(signature);
              });
          });
      }
    },
    approve() {
      let self = this;
      self.contract.methods
        .approve()
        .send({ from: self.$store.getters.getAccount })
        .on("receipt", function (res) {
          console.log("Signed", res);
        });
    },
    decline() {
      let self = this;
      self.contract.methods
        .decline()
        .send({ from: self.$store.getters.getAccount })
        .on("receipt", function (res) {
          console.log("Declined", res);
        });
    },
    downloadSigned() {
      this.modifyPdf();
    },
    async modifyPdf() {
      const url = this.documentPath;
      const existingPdfBytes = await fetch(url).then((res) =>
        res.arrayBuffer()
      );

      const pdfDoc = await PDFDocument.load(existingPdfBytes);
      const helveticaFont = await pdfDoc.embedFont(StandardFonts.Helvetica);

      const pages = pdfDoc.getPages();
      for(let pageIndex =0; pageIndex<pages.length; pageIndex++){
      const firstPage = pages[pageIndex];
      // eslint-disable-next-line no-unused-vars
      const { width, height } = firstPage.getSize();
      firstPage.drawText("Contract address "+this.contractHash, {
        x: 25,
        y: height - 50,
        size: 16,
        font: helveticaFont,
        color: rgb(0.223,0.223,0.223),
      });
      }

      // Add signing page
      const page = pdfDoc.addPage()
  // eslint-disable-next-line no-unused-vars
  const { width, height } = page.getSize()
  const fontSize = 21
  page.drawText('Signatures', {
    x: 50,
    y: height - 4 * fontSize,
    size: fontSize,
    font: helveticaFont,
    color: rgb(0, 0.53, 0.71),
  })

  for (let x=0; x < this.signatures.length; x++) {
    let text = this.signatures[x].owner
    let status = 'Pending'
    let status_code = this.signatures[x].status
    if (status_code === '1'){ status='Signed for'}
    if (status_code === '2') {status='Rejected'}
    text = text+' - ' + status
    page.drawText(text, {
      x: 50,
      y: 600*(x+1),
      size: fontSize-5,
      font: helveticaFont,
      color:rgb(0.223,0.223,0.223),
    })
  }

      // eslint-disable-next-line no-unused-vars
      const pdfBytes = await pdfDoc.save();
      const blob = new Blob([ pdfBytes ], { type: 'application/pdf' })
      FileSaver.saveAs(blob, this.contractHash + ".pdf");
      console.log(pdfBytes);
    },
  },
};
</script>