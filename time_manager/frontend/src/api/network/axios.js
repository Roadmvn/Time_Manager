import axios from 'axios';


export const http = axios.create({
	baseURL: process.env.VUE_APP_API_URL,
	withCredentials: true
});

http.defaults.headers.post['Content-Type'] = 'application/json';
