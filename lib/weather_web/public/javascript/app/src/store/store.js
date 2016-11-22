import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
    state: {
        current_user:'test'
    },

    mutations:{
        setCurrentUser (state,current_user){
            state.current_user = current_user
        },

    getters:{
        viewUser: state =>{
            return state.current_user
        }
    }
    }
})
