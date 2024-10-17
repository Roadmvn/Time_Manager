import axios from 'axios';


export const http = axios.create({
	baseURL: "http://20.19.81.174:4000/api/",
});

http.defaults.headers.post['Content-Type'] = 'application/json';
