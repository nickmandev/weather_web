import Vue from 'vue'
import VueRouter from 'vue-router'
import VueResource from 'vue-resource'
import App from './App.vue'

Vue.use(VueRouter)
Vue.use(VueResource)
Vue.http.options.root = '/';


const routes = [
    {path: '/', component:App},
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


