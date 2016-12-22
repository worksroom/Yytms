package com.youguu.ui;

import com.youguu.user.pojo.Parameter;
import com.youguu.user.service.IParameterService;
import com.youguu.util.AclCheck;
import com.youguu.util.ParameterUtil;
import com.youguu.util.SpringContextUtil;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 工厂类，实现数据库的Menu，Role，Privilege与LigerUi Tree的转换
 * 在将Menu变成LigerUi Tree过程中，需要递归遍历一个menu下面的子menu以及resource
 * 在将Role变成LigerUi Tree过程中，需要递归遍历一个privilege下面的子privilege
 * 在将Privilege变成
 *
 * @author luohong
 * @email 846705189@qq.com
 * @date 2014-12-18
 */
public class LigerUiToTree {
    IParameterService parameterService = (IParameterService) SpringContextUtil.getBean("parameterService");
    private static LigerUiToTree instance = new LigerUiToTree();

    public static LigerUiToTree getInstance() {
        return instance;
    }

    private LigerUiToTree() {

    }

    /**
     * 将数据库的Parameter变成符合LigerUi Tree组件
     *
     * @param parameter
     * @return
     */
    public ITree privilegeTree(Parameter parameter, HttpServletRequest request) {
        ITree tree = new LigerUiTree();

        tree.setId(parameter.getId());
        tree.setName(parameter.getName());
        if (parameter.getValue() != null && !"".equals(parameter.getValue())) {
            tree.setUrl(parameter.getValue());
        } else {
            tree.setPic("http://localhost:8888/lakeside/resources/ligerUI/skins/icons/archives.gif");
        }
        List<Parameter> list = ParameterUtil.getParameterParentList(parameter.getId());
        if (list != null && list.size() > 0) {
            for (Parameter p : list) {
                if(ParameterUtil.ACTION.equals(p.getType())){
                    continue;
                }
                String aclCode = p.getId();
                //权限判断
                if (!AclCheck.checkMenuAcl(request, aclCode)) {
                    continue;
                }

                ITree childTree = privilegeTree(p, request);
                tree.addSubTree(childTree);  //组织好数据


            }
        }
        return tree;
    }


    public ITree commonTree(Parameter parameter, HttpServletRequest request) {
        ITree tree = new LigerUiTree();
        tree.setId(parameter.getId());
        tree.setName(parameter.getName());
        tree.setIsChecked(true);
        if (parameter.getValue() != null && !"".equals(parameter.getValue())) {
            tree.setUrl(parameter.getValue());
        } else {
            tree.setPic("http://localhost:8888/lakeside/resources/ligerUI/skins/icons/archives.gif");
        }

        List<Parameter> list = parameterService.findParameterByPid(parameter.getId());
        if (list != null && list.size() > 0) {
            for (Parameter p : list) {
                ITree childTree = commonTree(p, request);
                tree.addSubTree(childTree);  //组织好数据
            }
        }
        return tree;
    }

    public ITree roleTree(Parameter parameter, List<String> mList, HttpServletRequest request) {
        ITree tree = new LigerUiTree();
        tree.setId(parameter.getId());
        tree.setName(parameter.getName());
        if (mList.contains(parameter.getId())) {
            tree.setIsChecked(true);
        }

        if (parameter.getValue() != null && !"".equals(parameter.getValue())) {
            tree.setUrl(parameter.getValue());
        } else {
            tree.setPic("http://localhost:8888/lakeside/resources/ligerUI/skins/icons/archives.gif");
        }

        List<Parameter> list = parameterService.findParameterByPid(parameter.getId());
        if (list != null && list.size() > 0) {
            for (Parameter p : list) {
                ITree childTree = roleTree(p, mList, request);
                tree.addSubTree(childTree);  //组织好数据
            }
        }
        System.out.println("dddddddddddddddddd=" + tree.ischecked());
        return tree;
    }

    private static ITree resourceToTree(Parameter res) {
        ITree childTree = new LigerUiTree();

        childTree.setId(res.getId());
        childTree.setName(res.getName());
        childTree.setUrl(res.getValue());
        childTree.setPic("");

        return childTree;
    }

}
