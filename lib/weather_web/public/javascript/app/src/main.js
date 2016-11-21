import Vue from 'vue'
import VueRouter from 'vue-router'
import VueResource from 'vue-resource'
import App from './App.vue'
import Favorite from './components/Favorite.vue'
import Signup from './components/Signup.vue'
import auth from './auth/auth'
Vue.use(VueRouter)
Vue.use(VueResource)

Vue.http.headers.common['Authorization'] = 'Bearer ' + localStorage.getItem('token')
auth.checkAuth()

export var router = new VueRouter({
    mode: 'history',
    routes: [
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
    ],
})
router.mode = 'html5'


const app = new Vue({
    el: '#app',
    router:router,
    render: h =>h(App)
})

