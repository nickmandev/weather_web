<template>
    <div id="login">
        <h4>Enter your credentials to log into your Account.</h4>
        <div class="row-fluid">
            <div class="col-xs-3">
                <div class="form-group">
                    <label class="text-center" for="usr">Username</label>
                    <input v-model="username" type="text" id="usr" class="form-control">
                    <label class="text-center" for="pass">Password</label>
                    <input v-model="password" type="password" id="pass" class="form-control">
                    <button class="btn btn-primary" type="submit"@click="submit">Logon</button>
                </div>
            </div>
        </div>
    </div>
</template>
<style>
    body{
        background-color: white;
    }
</style>
<script>
export default{
    name: 'login',
    data: function(){
        return {
            username: '',
            password: ''
        }
    },
        methods:{
            submit(){
            var data = {username: this.username,pass: this.password}

            this.$http.post('/api/login', data).then((response)=>{
                console.log('success')
            },(response)=>{
                console.log('fail')
            })
            }
       }

    }

</script>
