/*************************************************/
/****            FREE ev-FIBER 2.1            ****/
/*** Author: Seter#0909 | Project: NoPicks 3.5 ***/
/****      https://discord.gg/QZ4XAPUVps      ****/
/*************************************************/

export async function InitEvents() {};

let payload: Payload = null;

// UR PHONE RELATED SHIT
AddEventHandler("ev-fiber:phoneAPIReady", () => {
    // todo: Add a check as soon as phone is ready
    return true;
});
AddEventHandler("ev-fiber:updatePhoneStatus", (type: string, pObject: any) => {
    // todo: Update phone status, this is based on the phone u r using
});

CPX.Procedures.register("ev-fiber:verify:userRank", async (pRank: any) => {
    if (pRank == "dev" || pRank == "admin") {
        return true;
    }

    return false;
});

CPX.Procedures.register("np:fiber:player:init", async () => {
    return {
        token: payload.token,
        rest_api: payload.rest_api,
        socket_api: payload.socket_api,
        server_hash: payload.server_hash,
    }
});