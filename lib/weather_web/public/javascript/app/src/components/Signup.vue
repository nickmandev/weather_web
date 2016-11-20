<template>
    <div>
        <div v-if="error">
            <h5> {{error}} </h5>
        </div>
        <div class="form-group">
            <label  for="usr">Username</label>
            <input v-model="credentials.username" id="usr" type="text" class="form-control" >
            <label for="pass">Password</label>
            <input v-model="credentials.password" id="pass" type="password" class="form-control" >
            <label  for="confPass">Confirm password</label>
            <input v-model="credentials.confPassword" id="confPass" type="password" class="form-control">
            <button class="btn btn-primary" type="submit" @click="submit">SignUP</button>
        </div>
    </div>
</template>
<script>
    import auth from '../auth/auth'
    export default{
        data(){
            return{
                credentials: {
                    username:'',
                    password:'',
                    confPassword:''
                },
                error: ''
            }
        },
        methods:{
            submit(){
                if(this.credentials.password == this.credentials.confPassword){
                    var credentials = {
                            username: this.credentials.username,
                            password: this.credentials.password
                        }
                    this.$http.post('/api/signup',credentials).then(function(data){
                        this.error = 'Account created successfully'
                    }, (response)=> {
                        console.log(response)
                    })
                }else{
                    this.error = "Password field's must be identical"
                }

            }
        }
    }
</script>
