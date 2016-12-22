
window.NextEasy = {
    config: {
        singlePage : true,
        root: '/',
        domain: '',
        traceTime : false
    },

    appId: '',

    traceTime: function (str)
    {
        if (NextEasy.config.traceTime)
        {
            if (console && console.log)
            {
                var o = new Date();
                var timeStr = o.getHours() + ":" + o.getMinutes() + ":" + o.getSeconds() + "." + o.getMilliseconds();

                console.log((str || "") + " " + timeStr);
            }
        } 
    }
};