import Vue from 'vue'
import VueRouter from 'vue-router'
import VueResource from 'vue-resource'
import App from './App.vue'
import Favorite from './components/Favorite.vue'
import Signup from './components/Signup.vue'
import auth from './auth/auth'
Vue.use(VueRouter)
Vue.use(VueResource)



const routes = [
    {
        path: '/favorites',
        component: Favorite,
        beforeEnter: auth.requestAuth()
    },
    {
        path:'/signup',
        component: Signup
    },
]

export var router = new VueRouter({
    mode: 'history',
    routes
})
router.mode = 'html5'

const redirect = {redirect: '/home'}

const app = new Vue({
    el: '#app',
    router:router,
    render: h =>h(App)
})

