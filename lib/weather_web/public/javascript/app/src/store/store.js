import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
    state: {
        current_user:''
    },

    mutations:{
        setCurrentUser(state,current_user){
            state.current_user = current_user
        },

    getters:{
        viewUser: state =>{
            console.log("state.current_user")
            return state.current_user

        }
    }
    }
})
