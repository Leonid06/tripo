import PlanList from "../component/plan_list";
import PlanCreateButton from "../component/plan_create_button";
import fetchAllPlans from "../api/methods";
export default async function Page(){
    const plans = await fetchAllPlans()
    return (
        <>
            <PlanList plans={plans}></PlanList>
            <PlanCreateButton></PlanCreateButton>
        </>
        )
}