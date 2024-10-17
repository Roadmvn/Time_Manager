import axios from 'axios';


export const http = axios.create({
	baseURL: "http://127.0.0.1:4000/api/",
});

http.defaults.headers.post['Content-Type'] = 'application/json';
