import Header from "../../component/global/header";

export default function DashboardLayout({ children }) {
    return (
        <>
            <Header></Header>
            {children}
        </>
    )
}