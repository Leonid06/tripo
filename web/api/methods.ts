import {headers} from 'next/headers'
import {fetch} from "next/dist/compiled/@edge-runtime/primitives";

const API_URL = process.env.API_URL


async function makeApiCrudCall(route: string,  format : string, method: string,  body: string =null)  {
    const requestHeaders = { 'Content-Type': format }
    const incomingHeaders =  headers()
    requestHeaders['Bearer'] = incomingHeaders.get('bearer')
    const result  = await fetch(API_URL + route, {
        method: method,
        headers: requestHeaders,
        body: body
    })

    if(!result.ok) {
        throw new Error('Failed to fetch plans')
    }

    return result.json()
}

export default async function fetchAllPlans(){
    const data = await makeApiCrudCall(
        route= 'plan/get/all',
        format = 'application/json',
        method='GET')

}

export default async function fetchAccountInfoByToken(){

}

export default async function logOutByAccountToken(){

}