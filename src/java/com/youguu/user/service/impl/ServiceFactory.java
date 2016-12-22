package com.youguu.user.service.impl;

import com.youguu.user.service.IParameterService;

/**
 * Created by SomeBody on 2016/8/22.
 */
public class ServiceFactory {
    private static IParameterService parameterService = null;

    public static IParameterService getParameterService() {
        if (parameterService != null) {
            return parameterService;
        } else {
            synchronized (ServiceFactory.class) {
                if (parameterService != null) {
                    return parameterService;
                } else {
                    parameterService = new ParameterService();
                }
            }
        }
        return parameterService;
    }

}
