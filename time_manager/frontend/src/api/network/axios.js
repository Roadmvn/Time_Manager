import axios from 'axios';


export const http = axios.create({
	baseURL: "http://localhost:4000/api/",
});

http.defaults.headers.post['Content-Type'] = 'application/json';
