import axios from 'axios';


export const http = axios.create({
	baseURL: process.env.VUE_APP_API_URL
});

http.defaults.headers.post['Content-Type'] = 'application/json';
