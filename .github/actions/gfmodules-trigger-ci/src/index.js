const core = require("@actions/core");
const github = require("@actions/github");

async function run() {
    try {
        const oracHtpasswd = btoa(core.getInput("orac_htpasswd"));
        const endpointUrl = core.getInput("endpoint_url");

        const { eventName, payload, sha, ref } = github.context;
        const isMergedPr =
            eventName === "pull_request" && payload.pull_request.merged;
        const isDirectPush = eventName === "push" && ref === "refs/heads/main";

        if (!isMergedPr && !isDirectPush) {
            core.info("Not a merged PR or direct push to main - skipping");
            return;
        }

        const actor = github.context.actor;
        if (actor.includes("dependabot")) {
            core.info("Dependabot triggered this - skipping");
            return;
        }

        const data = {
            event_type: isMergedPr ? "pr_merged" : "direct_push",
            branch: ref,
            commit_sha: sha,
            pusher: actor,
        };

        if (isMergedPr) {
            data.pr_title = payload.pull_request.title;
            data.merger = payload.pull_request.merged_by.login;
        }

        const response = await fetch(endpointUrl, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Basic ${oracHtpasswd}`,
            },
            body: JSON.stringify(data),
        });
        if (!response.ok) {
            core.setFailed(
                `Failed to trigger TI Suite: ${response.status} ${response.statusText}`,
            );
            return;
        }

        core.info("Successfully triggered TI Suite");
    } catch (error) {
        core.setFailed(error.message);
    }
}

run();
