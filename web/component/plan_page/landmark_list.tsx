import LandmarkCard from "./landmark_card";
export default function LandmarkList({ landmarks }) {
    return (
        <ul role="list" className="divide-y divide-gray-100">
            {landmarks.map((landmark) => (
                <LandmarkCard landmark={landmark}></LandmarkCard>
            ))}
        </ul>
    )
}