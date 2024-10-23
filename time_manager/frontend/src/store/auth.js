import { http } from '@/api/network/axios'
import { defineStore } from 'pinia'


export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: null,
    user: null,
	isAuth: false
  }),
  getters: {
    isAuthenticated: (state) => !!state.token,
    userRole: (state) => state.user?.role,
  },
  actions: {
    async login(email, password) {
      try {
        const response = await http.post('/login', {"email": email, "password": password })
		console.log("Response", response);
		if (response.status !== 200) throw new Error('The returned status was not expected');

		this.getCurrentUser();
		return true;

      } catch (error) {
        console.error('Login failed:', error)
        throw error
      }
    },
    async logout() {
      try {
        await http.post('/logout')
        this.token = null
        this.user = null
      } catch (error) {
        console.error('Logout failed:', error)
        throw error
      }
    },
	async register(username, email, password) {
		try {
			const response = await http.post("/signup", {"user": {username, email, password}})
			if (response.status === 201) {
				return true;
			}
			console.log("Response", response);
		} catch (err) {
			console.error("signup failed", err)
			throw err
		}

	},
	async getCurrentUser() {
		const response = await http.get("/users/me")
		console.log("RESPONSE", response);
		this.isAuth = true;
		this.user = response.data.user
	}
  }
})