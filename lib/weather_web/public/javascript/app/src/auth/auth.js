const API_URL = 'http://localhost:9292'
const LOGIN_URL = API_URL + '/api/login'
const SIGN_UP_URL = API_URL + '/api/signup'

export default {


    authenticated: false,
    data: '',
    token: '',
    curr_user: '',

    logIn(contex,credentials){
        contex.$http.post(LOGIN_URL,credentials).then(function(data){
            this.data = JSON.parse(data.body)
            if(this.data['error']){
                contex.error = this.data['error']
            }else{
                this.curr_user = this.data['current_user']
                this.token = this.data['token']
                localStorage.setItem('token',this.token)
                this.authenticated = true
                this.$store.commit('setCurrentUser',this.curr_user)
            }

        },(response) => {
        contex.error = response
            })
    },

    signUp(contex,credentials){
        contex.$http.post(SIGN_UP_URL,credentials).then(function(data){
            contex.error = 'Account created successfully'
        }, (response)=> {
            contex.error = 'Error when creating!'
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