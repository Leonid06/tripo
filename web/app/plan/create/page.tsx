import SearchBar from "../../../component/plan_create_page/search_bar";
import PlanCreateButton from "../../../component/plan_create_page/create_button";
import PickedLandmarkPane from "../../../component/plan_create_page/picked_landmark_pane";

export default async function Page(){
    return (
        <>
            <SearchBar></SearchBar>
            <PickedLandmarkPane></PickedLandmarkPane>
            <PlanCreateButton></PlanCreateButton>
        </>
    )
}