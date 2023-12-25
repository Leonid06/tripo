// import fetchAllPlans from "../api/methods";
import PlanList from "../component/home_page/plan_list";
import PlanCreateButton from "../component/home_page/plan_create_button";
export default async function Page(){
    // const plans = await fetchAllPlans()
    return (
        <div className='bg-custom_bg_color p-10'>
            <PlanList plans={{}}></PlanList>
            <PlanCreateButton></PlanCreateButton>
        </div>
    )
}