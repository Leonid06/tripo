'use client'

import {useRouter} from "next/navigation";
import PlanDetailCard from "../../../component/plan_page/plan_detail_card";
import LandmarkList from "../../../component/plan_page/landmark_list";
import PlanDeleteButton from "../../../component/plan_page/plan_delete_button";

export default async function Page(){
    const router = useRouter()
    // const plan = fetchPlanById(router.query.identifier)
    const plan= {
        id: '',
        locations : [

        ]
    }
    return (
        <>
            <PlanDetailCard plan={plan}></PlanDetailCard>
            <LandmarkList landmarks={plan.locations}></LandmarkList>
            <PlanDeleteButton identifier={plan.id}></PlanDeleteButton>
        </>
    );
}