package cn.im47.cloud.storage.common.web.node;

import cn.im47.cloud.storage.common.entity.node.Node;
import cn.im47.cloud.storage.common.entity.node.NodeTypeEnum;
import cn.im47.cloud.storage.common.service.node.NodeManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * 存储结点控制器
 * <p/>
 * User: baitao.jibt@gmail.com
 * Date: 12-7-16
 * Time: 下午10:54
 */
@Controller
@RequestMapping(value = "/node")
public class NodeController {

    @Autowired
    private NodeManager nodeManager;

    private static final String APP_KEY = "";

    @RequestMapping(value = {"", "list"}, method = RequestMethod.GET)
    public String list(Model model) {
        model.addAttribute("node", new Node());
        model.addAttribute("types", NodeTypeEnum.values());
        model.addAttribute("nodes", nodeManager.getTree(APP_KEY));
        return "node/list";
    }

    @RequestMapping(value = "create", method = RequestMethod.GET)
    public String createFrom(Model model) {
        model.addAttribute("node", new Node());
        model.addAttribute("action", "create");
        model.addAttribute("types", NodeTypeEnum.values());
        model.addAttribute("nodes", nodeManager.getTree(APP_KEY));
        return "node/edit";
    }

    @RequestMapping(value = "create", method = RequestMethod.POST)
    public String create(RedirectAttributes redirectAttributes, Node node) {
        if (nodeManager.save(APP_KEY, node) > 0) {
            redirectAttributes.addFlashAttribute("info", "添加分类成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "添加分类失败");
        }
        return "redirect:/node/list";
    }

    @RequestMapping(value = "update/{id}", method = RequestMethod.GET)
    public String update(@PathVariable("id") Long id, Model model) {
        model.addAttribute("node", nodeManager.get(APP_KEY, id));
        model.addAttribute("action", "update");
        model.addAttribute("types", NodeTypeEnum.values());
        model.addAttribute("nodes", nodeManager.getTree(APP_KEY));
        return "node/edit";
    }

    @RequestMapping(value = "delete/{id}", method = RequestMethod.GET)
    public String delete(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        Node node = null;
        if (null != nodeManager.get(APP_KEY, id)) {
            node = nodeManager.get(APP_KEY, id);
            node.setNodeList(nodeManager.getChildren(APP_KEY, id));
        } else {
            redirectAttributes.addFlashAttribute("error", "该节点不存在");
            return "redirect:/node/list";
        }
        if (null != node.getNodeList() && 0 != node.getNodeList().size()) {
            redirectAttributes.addFlashAttribute("error", "该节点有子节点，不能删除");
        } else {
            if (nodeManager.delete(APP_KEY, id) > 0) {
                redirectAttributes.addFlashAttribute("info", "删除文件成功");
            } else {
                redirectAttributes.addFlashAttribute("error", "删除文件失败");
            }
        }
        return "redirect:/node/list";
    }

    @RequestMapping(value = "isUsedNodeName", method = RequestMethod.GET)
    @ResponseBody
    public boolean isUsedNodeName(@RequestParam("parentId") Long parentId, @RequestParam("nodeName") String nodeName) {
        return nodeManager.isUsedNodeName(APP_KEY, parentId, nodeName);
    }

}
