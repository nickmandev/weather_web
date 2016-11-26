import Vue from 'vue'
import VueRouter from 'vue-router'
import VueResource from 'vue-resource'
import Vuex from 'vuex'
import App from './App.vue'
import Favorite from './components/Favorite.vue'
import Signup from './components/Signup.vue'
import auth from './auth/auth'
import store from './store/store.js'

Vue.use(VueRouter)
Vue.use(VueResource)
Vue.use(Vuex)

Vue.http.headers.common['Authorization'] = 'Bearer ' + localStorage.getItem('token')


const routes = [
    {
        path: '/favorites',
        component: Favorite,
        beforeRouteEnter: auth.checkAuth()
    },
    {
        path:'/signup',
        component: Signup
    },
    {
        path: '/home',
        component: App
    }
    ]

const router = new VueRouter({
    routes,
    mode: 'history',
    redirect:{
        '*':'/home'
    },
    base: 'http://localhost:9292'
})

const app = new Vue({
    el: "#app",
    router:router,
    store,
    render: h => h(App)
})


