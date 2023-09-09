import fetchAllPlans from "../api/methods";
import PlanList from "../component/home_page/plan_list";
import PlanCreateButton from "../component/home_page/plan_create_button";

export default async function Page(){
    const plans = await fetchAllPlans()
    return (
        <>
            <PlanList plans={plans}></PlanList>
            <PlanCreateButton></PlanCreateButton>
        </>
    )
}