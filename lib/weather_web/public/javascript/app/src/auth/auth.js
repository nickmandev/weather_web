import {router} from '../main'
const API_URL = 'http://localhost:9292'
const LOGIN_URL = API_URL + '/api/login'
export default {


    authenticated: false,
    data: '',
    token: '',
    curr_user: '',

    logIn(contex,credentials,redirect){
        contex.$http.post(LOGIN_URL,credentials).then(function(data){
            this.data = JSON.parse(data.body)
            contex.current_user = this.data['current_user']
            this.curr_user = this.data['current_user']
            contex.isLoggedIn = true
            this.token = this.data['token']
            localStorage.setItem('token',this.token)
            this.authenticated = true
        },(response) => {
        contex.error = response
            })
    },

    logOut(contex){
        localStorage.removeItem('token')
        contex.current_user = ''
        this.authenticated = false
    },
    checkAuth(){
        var jwt = localStorage.getItem('token')
        if(jwt){
            this.authenticated = true
            console.log("checkAuth")
        }
        else{
            this.authenticated = false
        }
    },

    getAuthHeader(){
        return{
            'Authorization': 'Bearer ' + localStorage.getItem('token')
        }
    }
}