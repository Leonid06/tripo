import InfoCard from "../../../component/settings_page/info_card";
import LogOutButton from "../../../component/settings_page/log_out_button";
import fetchAccountInfoByToken from "../../../api/methods";
import fetchAccountToken from "../../../local/header_methods";

export default async function Page(){
    const accountToken = fetchAccountToken()
    const accountInfo = fetchAccountInfoByToken()
    return (
        <>
           <InfoCard accountInfo={ accountInfo }></InfoCard>
            <LogOutButton accountToken = { accountToken }></LogOutButton>
        </>
    );
}