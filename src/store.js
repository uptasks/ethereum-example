import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    contract: "",
    account: ""
  },
  getters: {
    getContract(state) {
      return state.contract
    },
    getAccount(state) {
      return state.account
    }
  },
  mutations: {
    setContract(state, contract) {
      state.contract = contract;
    },
    setAccount(state, account) {
      state.account = account;
    }
  }
})

export default store;