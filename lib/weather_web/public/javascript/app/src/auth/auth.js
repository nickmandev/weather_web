
export default {
    user:{
        authenticated: false
    },

    logIn(contex,credentials){
        contex.$http.post('/api/login',credentials).then(function(data){
            contex.current_user = JSON.parse(data.body)
            contex.isLoggedIn = true
            this.user.authenticated = true
        },(response) => {
        contex.error = response
            })
    },
    logOut(contex){
        contex.current_user = ''
        this.user.authenticated = false
    },
    requestAuth(){
        return this.user.authenticated
    },
}