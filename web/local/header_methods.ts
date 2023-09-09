import {headers} from "next/headers";

export default function fetchAccountToken(){
    const currentHeaders = headers()
    return currentHeaders.get('Bearer')
}