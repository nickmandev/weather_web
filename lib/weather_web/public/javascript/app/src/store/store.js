import Vue from 'vue'
import Vuex from 'vuex'
import Search from '../components/Search.vue'

Vue.use(Vuex)

export default new Vuex.Store({
    state: {
        current_user:'',
        favorites: [],
        forecast: [],
        cityName: ''
    },

    mutations:{
        setCurrentUser(state,current_user){
            state.current_user = current_user
        },

        setFavorites(state,array){
            state.favorites = array
        },

        setForecast(state,array){
            state.forecast = array
        },

        setCityName(state,name){
            state.cityName = name
        }

    },

    getters:{
        getCityName: state=> {
            return state.cityName
        }
    }
})
