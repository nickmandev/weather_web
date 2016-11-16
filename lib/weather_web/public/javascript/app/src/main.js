import Vue from 'vue'
import VueRouter from 'vue-router'
import App from './App.vue'
import Login from './views/Login.vue'


Vue.use(VueRouter)

const routes = [
    {path: '/login', component: Login}
]

const router = new VueRouter({
    mode: 'history',
    routes
})
router.mode = 'html5'


new Vue({
    el: '#app',
    router: router,
    components: [

    ],
    render: h => h(App)
});


