import Vue from 'vue'
import VueRouter from 'vue-router'
import VueResource from 'vue-resource'
import App from './App.vue'
import Login from './views/Login.vue'
import Signup from './views/Signup.vue'

Vue.use(VueRouter)
Vue.use(VueResource)
Vue.http.options.root = '/';


const routes = [
    {path: '/login', component: Login},
    {path: '/home', component:App},
    {path: '/signup', component:Signup}
]

const router = new VueRouter({
    mode: 'history',
    routes
})
router.mode = 'html5'


new Vue({
    el: '#app',
    router: router,
    render: h => h(App)
});


